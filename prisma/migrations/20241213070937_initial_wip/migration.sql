/*
  Warnings:

  - You are about to drop the `Post` table. If the table is not empty, all the data it contains will be lost.

*/
-- CreateEnum
CREATE TYPE "Status" AS ENUM ('Active', 'Compeleted');

-- CreateEnum
CREATE TYPE "CustomerType" AS ENUM ('New', 'Old');

-- DropForeignKey
ALTER TABLE "Post" DROP CONSTRAINT "Post_user_id_fkey";

-- DropTable
DROP TABLE "Post";

-- CreateTable
CREATE TABLE "State" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,

    CONSTRAINT "State_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Customer" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,

    CONSTRAINT "Customer_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Scope" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,

    CONSTRAINT "Scope_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Category" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,

    CONSTRAINT "Category_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Material" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,

    CONSTRAINT "Material_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "EnquiryRegister" (
    "id" TEXT NOT NULL,
    "customerId" TEXT NOT NULL,
    "EnquiryReference" TEXT NOT NULL,
    "customer_type" "CustomerType" NOT NULL,

    CONSTRAINT "EnquiryRegister_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "EnquiryItem" (
    "id" TEXT NOT NULL,
    "date" TIMESTAMP(3) NOT NULL,
    "description" TEXT NOT NULL,
    "drawingNumber" TEXT[],
    "scopeId" TEXT NOT NULL,
    "categoryId" TEXT NOT NULL,
    "quantity" INTEGER NOT NULL,
    "enquiryId" TEXT NOT NULL,
    "MFG" BOOLEAN NOT NULL DEFAULT true,
    "TEC" BOOLEAN NOT NULL DEFAULT true,
    "COM" BOOLEAN NOT NULL DEFAULT true,
    "SLNO" BOOLEAN NOT NULL DEFAULT true,
    "special_process" BOOLEAN NOT NULL,
    "status" "Status" NOT NULL,

    CONSTRAINT "EnquiryItem_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Quotation" (
    "id" TEXT NOT NULL,

    CONSTRAINT "Quotation_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "QuotationItem" (
    "id" TEXT NOT NULL,
    "quotationId" TEXT NOT NULL,
    "quotationDate" TIMESTAMP(3) NOT NULL,
    "enquiryItemId" TEXT NOT NULL,
    "costPerEach" DOUBLE PRECISION NOT NULL,
    "totalCost" DOUBLE PRECISION NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "remarks" TEXT NOT NULL,

    CONSTRAINT "QuotationItem_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "PurchaseOrderRegister" (
    "id" TEXT NOT NULL,
    "confirmationDate" TIMESTAMP(3) NOT NULL,
    "discount" DOUBLE PRECISION NOT NULL,
    "discountedValue" DOUBLE PRECISION NOT NULL,
    "tfterDiscount" DOUBLE PRECISION NOT NULL,
    "vat" DOUBLE PRECISION NOT NULL,
    "totalCostEach" DOUBLE PRECISION NOT NULL,
    "totalPOValue" DOUBLE PRECISION NOT NULL,
    "DispatchSchedule" TIMESTAMP(3) NOT NULL,
    "InvoiceNo" TEXT NOT NULL,
    "BalanceDeliveryQty" INTEGER NOT NULL,
    "BalanceInvoiceQty" INTEGER NOT NULL,
    "BalanceValue" INTEGER NOT NULL,

    CONSTRAINT "PurchaseOrderRegister_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ProcessPlanRegister" (
    "id" TEXT NOT NULL,

    CONSTRAINT "ProcessPlanRegister_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ItemDetailsMaterial" (
    "id" TEXT NOT NULL,
    "enquiryItemId" TEXT NOT NULL,
    "materialId" TEXT NOT NULL,

    CONSTRAINT "ItemDetailsMaterial_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "Material_name_key" ON "Material"("name");

-- CreateIndex
CREATE UNIQUE INDEX "QuotationItem_enquiryItemId_key" ON "QuotationItem"("enquiryItemId");

-- CreateIndex
CREATE UNIQUE INDEX "ItemDetailsMaterial_enquiryItemId_materialId_key" ON "ItemDetailsMaterial"("enquiryItemId", "materialId");

-- AddForeignKey
ALTER TABLE "EnquiryRegister" ADD CONSTRAINT "EnquiryRegister_customerId_fkey" FOREIGN KEY ("customerId") REFERENCES "Customer"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "EnquiryItem" ADD CONSTRAINT "EnquiryItem_scopeId_fkey" FOREIGN KEY ("scopeId") REFERENCES "Scope"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "EnquiryItem" ADD CONSTRAINT "EnquiryItem_categoryId_fkey" FOREIGN KEY ("categoryId") REFERENCES "Category"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "EnquiryItem" ADD CONSTRAINT "EnquiryItem_enquiryId_fkey" FOREIGN KEY ("enquiryId") REFERENCES "EnquiryRegister"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "QuotationItem" ADD CONSTRAINT "QuotationItem_quotationId_fkey" FOREIGN KEY ("quotationId") REFERENCES "Quotation"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "QuotationItem" ADD CONSTRAINT "QuotationItem_enquiryItemId_fkey" FOREIGN KEY ("enquiryItemId") REFERENCES "EnquiryItem"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ItemDetailsMaterial" ADD CONSTRAINT "ItemDetailsMaterial_enquiryItemId_fkey" FOREIGN KEY ("enquiryItemId") REFERENCES "EnquiryItem"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ItemDetailsMaterial" ADD CONSTRAINT "ItemDetailsMaterial_materialId_fkey" FOREIGN KEY ("materialId") REFERENCES "Material"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
