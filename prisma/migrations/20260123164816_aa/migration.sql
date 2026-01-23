-- CreateEnum
CREATE TYPE "Role" AS ENUM ('USER', 'ADMIN');

-- CreateEnum
CREATE TYPE "SubscriptionStatus" AS ENUM ('active', 'expired', 'cancelled', 'grace_period');

-- CreateEnum
CREATE TYPE "Platform" AS ENUM ('ios', 'android', 'stripe');

-- CreateEnum
CREATE TYPE "MediaType" AS ENUM ('video', 'article');

-- CreateEnum
CREATE TYPE "EventStatus" AS ENUM ('scheduled', 'live', 'ended');

-- CreateEnum
CREATE TYPE "ChallengeType" AS ENUM ('physical', 'diet', 'mental');

-- CreateTable
CREATE TABLE "users" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "email" TEXT NOT NULL,
    "password" TEXT NOT NULL,
    "full_name" TEXT,
    "avatar_url" TEXT,
    "role" "Role" NOT NULL DEFAULT 'USER',
    "due_date" DATE NOT NULL,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "users_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "subscriptions" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "user_id" UUID NOT NULL,
    "status" "SubscriptionStatus" NOT NULL DEFAULT 'active',
    "platform" "Platform" NOT NULL,
    "original_transaction_id" TEXT NOT NULL,
    "start_date" TIMESTAMPTZ NOT NULL,
    "expires_at" TIMESTAMPTZ NOT NULL,
    "is_auto_renew" BOOLEAN NOT NULL DEFAULT true,

    CONSTRAINT "subscriptions_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "weeks_metadata" (
    "week_num" INTEGER NOT NULL,
    "baby_image_url" TEXT NOT NULL,
    "baby_size_comparison" TEXT,
    "description" TEXT,

    CONSTRAINT "weeks_metadata_pkey" PRIMARY KEY ("week_num")
);

-- CreateTable
CREATE TABLE "content_library" (
    "id" SERIAL NOT NULL,
    "week_num" INTEGER NOT NULL,
    "title" TEXT NOT NULL,
    "thumbnail_url" TEXT,
    "media_url" TEXT NOT NULL,
    "media_type" "MediaType" NOT NULL DEFAULT 'video',
    "category" TEXT,
    "is_premium" BOOLEAN NOT NULL DEFAULT true,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "content_library_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "community_posts" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "user_id" UUID,
    "content" TEXT,
    "image_url" TEXT,
    "likes_count" INTEGER NOT NULL DEFAULT 0,
    "comments_count" INTEGER NOT NULL DEFAULT 0,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "community_posts_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "community_comments" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "post_id" UUID NOT NULL,
    "user_id" UUID NOT NULL,
    "content" TEXT NOT NULL,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "community_comments_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "groups" (
    "id" SERIAL NOT NULL,
    "name" TEXT NOT NULL,
    "description" TEXT,
    "icon_url" TEXT,

    CONSTRAINT "groups_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "group_messages" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "group_id" INTEGER NOT NULL,
    "user_id" UUID NOT NULL,
    "message_body" TEXT,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "group_messages_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "live_events" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "title" TEXT NOT NULL,
    "description" TEXT,
    "scheduled_at" TIMESTAMPTZ NOT NULL,
    "zoom_embed_url" TEXT NOT NULL,
    "expert_name" TEXT,
    "status" "EventStatus" NOT NULL DEFAULT 'scheduled',
    "is_premium" BOOLEAN NOT NULL DEFAULT true,

    CONSTRAINT "live_events_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "daily_logs" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "user_id" UUID NOT NULL,
    "log_date" DATE NOT NULL,
    "weight_kg" DECIMAL(5,2),
    "mood_score" INTEGER,
    "symptoms" JSONB,
    "water_intake_ml" INTEGER,
    "notes" TEXT,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "daily_logs_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "challenges" (
    "id" SERIAL NOT NULL,
    "week_num" INTEGER,
    "title" TEXT NOT NULL,
    "description" TEXT,
    "type" "ChallengeType",

    CONSTRAINT "challenges_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "user_challenge_progress" (
    "user_id" UUID NOT NULL,
    "challenge_id" INTEGER NOT NULL,
    "completed_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "user_challenge_progress_pkey" PRIMARY KEY ("user_id","challenge_id")
);

-- CreateIndex
CREATE UNIQUE INDEX "users_email_key" ON "users"("email");

-- CreateIndex
CREATE UNIQUE INDEX "subscriptions_original_transaction_id_key" ON "subscriptions"("original_transaction_id");

-- CreateIndex
CREATE INDEX "content_library_week_num_category_idx" ON "content_library"("week_num", "category");

-- CreateIndex
CREATE INDEX "group_messages_group_id_created_at_idx" ON "group_messages"("group_id", "created_at");

-- CreateIndex
CREATE UNIQUE INDEX "daily_logs_user_id_log_date_key" ON "daily_logs"("user_id", "log_date");

-- AddForeignKey
ALTER TABLE "subscriptions" ADD CONSTRAINT "subscriptions_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "content_library" ADD CONSTRAINT "content_library_week_num_fkey" FOREIGN KEY ("week_num") REFERENCES "weeks_metadata"("week_num") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "community_posts" ADD CONSTRAINT "community_posts_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "community_comments" ADD CONSTRAINT "community_comments_post_id_fkey" FOREIGN KEY ("post_id") REFERENCES "community_posts"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "community_comments" ADD CONSTRAINT "community_comments_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "group_messages" ADD CONSTRAINT "group_messages_group_id_fkey" FOREIGN KEY ("group_id") REFERENCES "groups"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "group_messages" ADD CONSTRAINT "group_messages_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "daily_logs" ADD CONSTRAINT "daily_logs_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "challenges" ADD CONSTRAINT "challenges_week_num_fkey" FOREIGN KEY ("week_num") REFERENCES "weeks_metadata"("week_num") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "user_challenge_progress" ADD CONSTRAINT "user_challenge_progress_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "user_challenge_progress" ADD CONSTRAINT "user_challenge_progress_challenge_id_fkey" FOREIGN KEY ("challenge_id") REFERENCES "challenges"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
