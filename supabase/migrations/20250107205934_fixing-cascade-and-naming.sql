alter table "public"."photos" drop constraint "photos_uploaded_by_fkey";

alter table "public"."photos" alter column "uploaded_by" drop default;

alter table "public"."photos" alter column "uploaded_by" drop not null;

alter table "public"."profiles" add column "ordered_photos" uuid[] not null default '{}'::uuid[];

alter table "public"."sub_profile" drop column "oredered_photos";

alter table "public"."sub_profile" add column "ordered_photos" uuid[] not null default '{}'::uuid[];

alter table "public"."photos" add constraint "photos_profile_id_fkey" FOREIGN KEY (profile_id) REFERENCES profiles(id) ON UPDATE CASCADE ON DELETE CASCADE not valid;

alter table "public"."photos" validate constraint "photos_profile_id_fkey";

alter table "public"."photos" add constraint "photos_uploaded_by_fkey" FOREIGN KEY (uploaded_by) REFERENCES users(id) ON UPDATE CASCADE ON DELETE SET NULL not valid;

alter table "public"."photos" validate constraint "photos_uploaded_by_fkey";


