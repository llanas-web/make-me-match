create table "public"."profiles" (
    "id" uuid not null default gen_random_uuid(),
    "created_at" timestamp with time zone not null default now(),
    "user_id" uuid default gen_random_uuid()
);


alter table "public"."profiles" enable row level security;

alter table "public"."users" alter column "email" set not null;

alter table "public"."users" alter column "username" set not null;

CREATE UNIQUE INDEX profile_pkey ON public.profiles USING btree (id);

alter table "public"."profiles" add constraint "profile_pkey" PRIMARY KEY using index "profile_pkey";

alter table "public"."profiles" add constraint "profiles_user_id_fkey" FOREIGN KEY (user_id) REFERENCES users(id) not valid;

alter table "public"."profiles" validate constraint "profiles_user_id_fkey";

grant delete on table "public"."profiles" to "anon";

grant insert on table "public"."profiles" to "anon";

grant references on table "public"."profiles" to "anon";

grant select on table "public"."profiles" to "anon";

grant trigger on table "public"."profiles" to "anon";

grant truncate on table "public"."profiles" to "anon";

grant update on table "public"."profiles" to "anon";

grant delete on table "public"."profiles" to "authenticated";

grant insert on table "public"."profiles" to "authenticated";

grant references on table "public"."profiles" to "authenticated";

grant select on table "public"."profiles" to "authenticated";

grant trigger on table "public"."profiles" to "authenticated";

grant truncate on table "public"."profiles" to "authenticated";

grant update on table "public"."profiles" to "authenticated";

grant delete on table "public"."profiles" to "service_role";

grant insert on table "public"."profiles" to "service_role";

grant references on table "public"."profiles" to "service_role";

grant select on table "public"."profiles" to "service_role";

grant trigger on table "public"."profiles" to "service_role";

grant truncate on table "public"."profiles" to "service_role";

grant update on table "public"."profiles" to "service_role";

create policy "Enable insert for users based on user_id"
on "public"."profiles"
as permissive
for insert
to authenticated
with check ((( SELECT auth.uid() AS uid) = user_id));


create policy "Enable users to view their own data only"
on "public"."profiles"
as permissive
for select
to authenticated
using ((( SELECT auth.uid() AS uid) = user_id));


create policy "Enable user to view their own data"
on "public"."users"
as permissive
for select
to authenticated
using ((( SELECT auth.uid() AS uid) = id));



