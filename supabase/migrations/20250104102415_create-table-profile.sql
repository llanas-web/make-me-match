drop policy "Enable insert for users based on user_id" on "public"."profiles";

drop policy "Enable users to view their own data only" on "public"."profiles";

alter table "public"."profiles" drop constraint "profiles_user_id_fkey";

create table "public"."photos" (
    "id" uuid not null default gen_random_uuid(),
    "created_at" timestamp with time zone not null default now(),
    "uploaded_by" uuid not null default gen_random_uuid(),
    "profile_id" uuid not null default gen_random_uuid()
);


alter table "public"."photos" enable row level security;

alter table "public"."profiles" drop column "user_id";

CREATE UNIQUE INDEX photos_pkey ON public.photos USING btree (id);

alter table "public"."photos" add constraint "photos_pkey" PRIMARY KEY using index "photos_pkey";

alter table "public"."photos" add constraint "photos_uploaded_by_fkey" FOREIGN KEY (uploaded_by) REFERENCES users(id) not valid;

alter table "public"."photos" validate constraint "photos_uploaded_by_fkey";

alter table "public"."profiles" add constraint "profiles_id_fkey" FOREIGN KEY (id) REFERENCES users(id) not valid;

alter table "public"."profiles" validate constraint "profiles_id_fkey";

grant delete on table "public"."photos" to "anon";

grant insert on table "public"."photos" to "anon";

grant references on table "public"."photos" to "anon";

grant select on table "public"."photos" to "anon";

grant trigger on table "public"."photos" to "anon";

grant truncate on table "public"."photos" to "anon";

grant update on table "public"."photos" to "anon";

grant delete on table "public"."photos" to "authenticated";

grant insert on table "public"."photos" to "authenticated";

grant references on table "public"."photos" to "authenticated";

grant select on table "public"."photos" to "authenticated";

grant trigger on table "public"."photos" to "authenticated";

grant truncate on table "public"."photos" to "authenticated";

grant update on table "public"."photos" to "authenticated";

grant delete on table "public"."photos" to "service_role";

grant insert on table "public"."photos" to "service_role";

grant references on table "public"."photos" to "service_role";

grant select on table "public"."photos" to "service_role";

grant trigger on table "public"."photos" to "service_role";

grant truncate on table "public"."photos" to "service_role";

grant update on table "public"."photos" to "service_role";

create policy "Enable insert for users based on id"
on "public"."profiles"
as permissive
for insert
to authenticated
with check ((( SELECT auth.uid() AS uid) = id));


create policy "Enable users to view their own data only"
on "public"."profiles"
as permissive
for select
to authenticated
using ((( SELECT auth.uid() AS uid) = id));



