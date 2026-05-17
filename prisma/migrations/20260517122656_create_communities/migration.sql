/*
  Warnings:

  - You are about to drop the `Community` table. If the table is not empty, all the data it contains will be lost.

*/
-- DropIndex
DROP INDEX "Community_name_key";

-- DropTable
PRAGMA foreign_keys=off;
DROP TABLE "Community";
PRAGMA foreign_keys=on;

-- CreateTable
CREATE TABLE "communities" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "name" TEXT NOT NULL,
    "description" TEXT,
    "visibility" TEXT NOT NULL DEFAULT 'PUBLIC',
    "status" TEXT NOT NULL DEFAULT 'ACTIVE',
    "createdById" INTEGER NOT NULL,
    "createdAt" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" DATETIME NOT NULL,
    CONSTRAINT "communities_createdById_fkey" FOREIGN KEY ("createdById") REFERENCES "User" ("id") ON DELETE RESTRICT ON UPDATE CASCADE
);

-- RedefineTables
PRAGMA defer_foreign_keys=ON;
PRAGMA foreign_keys=OFF;
CREATE TABLE "new_CommunityMember" (
    "userId" INTEGER NOT NULL,
    "communityId" INTEGER NOT NULL,
    "role" TEXT NOT NULL DEFAULT 'MEMBER',
    "joinedAt" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY ("userId", "communityId"),
    CONSTRAINT "CommunityMember_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User" ("id") ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT "CommunityMember_communityId_fkey" FOREIGN KEY ("communityId") REFERENCES "communities" ("id") ON DELETE RESTRICT ON UPDATE CASCADE
);
INSERT INTO "new_CommunityMember" ("communityId", "joinedAt", "userId") SELECT "communityId", "joinedAt", "userId" FROM "CommunityMember";
DROP TABLE "CommunityMember";
ALTER TABLE "new_CommunityMember" RENAME TO "CommunityMember";
CREATE TABLE "new_Post" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "title" TEXT NOT NULL,
    "body" TEXT,
    "createdAt" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "userId" INTEGER NOT NULL,
    "communityId" INTEGER NOT NULL,
    CONSTRAINT "Post_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User" ("id") ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT "Post_communityId_fkey" FOREIGN KEY ("communityId") REFERENCES "communities" ("id") ON DELETE RESTRICT ON UPDATE CASCADE
);
INSERT INTO "new_Post" ("body", "communityId", "createdAt", "id", "title", "userId") SELECT "body", "communityId", "createdAt", "id", "title", "userId" FROM "Post";
DROP TABLE "Post";
ALTER TABLE "new_Post" RENAME TO "Post";
PRAGMA foreign_keys=ON;
PRAGMA defer_foreign_keys=OFF;

-- CreateIndex
CREATE UNIQUE INDEX "communities_name_key" ON "communities"("name");
