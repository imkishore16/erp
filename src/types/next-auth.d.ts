import { type DefaultSession } from "next-auth";

declare module "next-auth" {
    interface Session {
      user: {
        id: string;
        email: string;
        // Add accessToken here
        accessToken: string;
      } & DefaultSession["user"];
    }
  }
  
  declare module "next-auth/jwt" {
    interface JWT {
      id: string; // Ensure id is always a string
      email: string;
      // Add accessToken here
      accessToken: string;
    }
  }
  