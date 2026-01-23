/*
  Warnings:

  - You are about to drop the column `due_date` on the `users` table. All the data in the column will be lost.
  - You are about to drop the `challenges` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `community_comments` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `community_posts` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `content_library` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `daily_logs` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `group_messages` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `groups` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `live_events` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `subscriptions` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `user_challenge_progress` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `weeks_metadata` table. If the table is not empty, all the data it contains will be lost.

*/
-- DropForeignKey
ALTER TABLE "challenges" DROP CONSTRAINT "challenges_week_num_fkey";

-- DropForeignKey
ALTER TABLE "community_comments" DROP CONSTRAINT "community_comments_post_id_fkey";

-- DropForeignKey
ALTER TABLE "community_comments" DROP CONSTRAINT "community_comments_user_id_fkey";

-- DropForeignKey
ALTER TABLE "community_posts" DROP CONSTRAINT "community_posts_user_id_fkey";

-- DropForeignKey
ALTER TABLE "content_library" DROP CONSTRAINT "content_library_week_num_fkey";

-- DropForeignKey
ALTER TABLE "daily_logs" DROP CONSTRAINT "daily_logs_user_id_fkey";

-- DropForeignKey
ALTER TABLE "group_messages" DROP CONSTRAINT "group_messages_group_id_fkey";

-- DropForeignKey
ALTER TABLE "group_messages" DROP CONSTRAINT "group_messages_user_id_fkey";

-- DropForeignKey
ALTER TABLE "subscriptions" DROP CONSTRAINT "subscriptions_user_id_fkey";

-- DropForeignKey
ALTER TABLE "user_challenge_progress" DROP CONSTRAINT "user_challenge_progress_challenge_id_fkey";

-- DropForeignKey
ALTER TABLE "user_challenge_progress" DROP CONSTRAINT "user_challenge_progress_user_id_fkey";

-- AlterTable
ALTER TABLE "users" DROP COLUMN "due_date";

-- DropTable
DROP TABLE "challenges";

-- DropTable
DROP TABLE "community_comments";

-- DropTable
DROP TABLE "community_posts";

-- DropTable
DROP TABLE "content_library";

-- DropTable
DROP TABLE "daily_logs";

-- DropTable
DROP TABLE "group_messages";

-- DropTable
DROP TABLE "groups";

-- DropTable
DROP TABLE "live_events";

-- DropTable
DROP TABLE "subscriptions";

-- DropTable
DROP TABLE "user_challenge_progress";

-- DropTable
DROP TABLE "weeks_metadata";

-- DropEnum
DROP TYPE "ChallengeType";

-- DropEnum
DROP TYPE "EventStatus";

-- DropEnum
DROP TYPE "MediaType";

-- DropEnum
DROP TYPE "Platform";

-- DropEnum
DROP TYPE "SubscriptionStatus";
