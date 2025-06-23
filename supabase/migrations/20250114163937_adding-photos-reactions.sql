alter table "public"."photos" add column "reactions" jsonb not null default '{}'::jsonb;


