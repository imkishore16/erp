import { NextAuthOptions, Session } from "next-auth";
import bcrypt from "bcryptjs";
import Credentials from "next-auth/providers/credentials";
import { emailSchema, passwordSchema } from "schema/credentials-schema";
import { PrismaClientInitializationError } from "@prisma/client/runtime/library";
import prisma from "lib/db";

export const authOptions = {
  providers: [
    Credentials({
      credentials: {
        email: { type: "email" },
        password: { type: "password" },
      },
      async authorize(credentials) {
        if (!credentials || !credentials.email || !credentials.password) {
          throw new Error("Email and password are required");
        }

        const emailValidation = emailSchema.safeParse(credentials.email);
        if (!emailValidation.success) {
          throw new Error("Invalid email");
        }

        const passwordValidation = passwordSchema.safeParse(credentials.password);
        if (!passwordValidation.success) {
          throw new Error(passwordValidation.error.issues[0].message);
        }

        try {
          const user = await prisma.user.findUnique({
            where: { email: emailValidation.data },
          });

          if (!user) {
            // User not found, create a new user
            const hashedPassword = await bcrypt.hash(passwordValidation.data, 10);
            const newUser = await prisma.user.create({
              data: {
                email: emailValidation.data,
                password: hashedPassword,
              },
            });
            return newUser;
          }

          if (!user.password) {
            // If the user exists but has no password, set a new password
            const hashedPassword = await bcrypt.hash(passwordValidation.data, 10);
            const updatedUser = await prisma.user.update({
              where: { email: emailValidation.data },
              data: { password: hashedPassword },
            });
            return updatedUser;
          }

          // Verify password
          const passwordValid = await bcrypt.compare(passwordValidation.data, user.password);
          if (!passwordValid) {
            throw new Error("Invalid password");
          }

          return user;
        } catch (error) {
          if (error instanceof PrismaClientInitializationError) {
            throw new Error("Internal server error");
          }
          console.error(error);
          throw error;
        }
      },
    }),
  ],
  pages: {
    signIn: "/auth",
  },
  secret: process.env.NEXTAUTH_SECRET ?? "secret",
  session: {
    strategy: "jwt",
  },
  callbacks: {
    async jwt({ token, user }) {
      if (user) {
        token.id = user.id;
        token.email = user.email ?? "";
      }
      return token;
    },

    async session({ session, token }) {
      session.user = {
        id: token.id,
        email: token.email,
        accessToken: token.accessToken ?? ''
      };
      return session;
    },
  },
} satisfies NextAuthOptions;
