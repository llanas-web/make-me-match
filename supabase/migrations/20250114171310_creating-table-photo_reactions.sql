create type "public"."photos_reactions" as enum ('like');

drop view if exists "public"."selected_photos_profile";

create table "public"."photo_reactions" (
    "photo_id" uuid not null,
    "created_at" timestamp with time zone not null default now(),
    "user_id" uuid not null,
    "updated_at" time with time zone not null default now(),
    "reaction" photos_reactions not null
);


alter table "public"."photo_reactions" enable row level security;

alter table "public"."photos" drop column "reactions";

CREATE UNIQUE INDEX photo_reactions_pkey ON public.photo_reactions USING btree (photo_id, user_id);

alter table "public"."photo_reactions" add constraint "photo_reactions_pkey" PRIMARY KEY using index "photo_reactions_pkey";

alter table "public"."photo_reactions" add constraint "photo_reactions_photo_id_fkey" FOREIGN KEY (photo_id) REFERENCES photos(id) ON UPDATE CASCADE ON DELETE CASCADE not valid;

alter table "public"."photo_reactions" validate constraint "photo_reactions_photo_id_fkey";

alter table "public"."photo_reactions" add constraint "photo_reactions_user_id_fkey" FOREIGN KEY (user_id) REFERENCES users(id) ON UPDATE CASCADE ON DELETE CASCADE not valid;

alter table "public"."photo_reactions" validate constraint "photo_reactions_user_id_fkey";

create or replace view "public"."selected_photos_profile" as  SELECT selected_photos.photo_id,
    selected_photos.user_id,
    selected_photos."order",
    photos.profile_id
   FROM (selected_photos
     LEFT JOIN photos ON ((selected_photos.photo_id = photos.id)));


grant delete on table "public"."photo_reactions" to "anon";

grant insert on table "public"."photo_reactions" to "anon";

grant references on table "public"."photo_reactions" to "anon";

grant select on table "public"."photo_reactions" to "anon";

grant trigger on table "public"."photo_reactions" to "anon";

grant truncate on table "public"."photo_reactions" to "anon";

grant update on table "public"."photo_reactions" to "anon";

grant delete on table "public"."photo_reactions" to "authenticated";

grant insert on table "public"."photo_reactions" to "authenticated";

grant references on table "public"."photo_reactions" to "authenticated";

grant select on table "public"."photo_reactions" to "authenticated";

grant trigger on table "public"."photo_reactions" to "authenticated";

grant truncate on table "public"."photo_reactions" to "authenticated";

grant update on table "public"."photo_reactions" to "authenticated";

grant delete on table "public"."photo_reactions" to "service_role";

grant insert on table "public"."photo_reactions" to "service_role";

grant references on table "public"."photo_reactions" to "service_role";

grant select on table "public"."photo_reactions" to "service_role";

grant trigger on table "public"."photo_reactions" to "service_role";

grant truncate on table "public"."photo_reactions" to "service_role";

grant update on table "public"."photo_reactions" to "service_role";


