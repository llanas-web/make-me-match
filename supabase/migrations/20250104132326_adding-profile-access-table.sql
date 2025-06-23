create table "public"."profile_access" (
    "profile_id" uuid not null default gen_random_uuid(),
    "created_at" timestamp with time zone not null default now(),
    "user_id" uuid not null default gen_random_uuid()
);


alter table "public"."profile_access" enable row level security;

CREATE UNIQUE INDEX profile_access_pkey ON public.profile_access USING btree (profile_id, user_id);

alter table "public"."profile_access" add constraint "profile_access_pkey" PRIMARY KEY using index "profile_access_pkey";

alter table "public"."profile_access" add constraint "profile_access_profile_id_fkey" FOREIGN KEY (profile_id) REFERENCES profiles(id) not valid;

alter table "public"."profile_access" validate constraint "profile_access_profile_id_fkey";

alter table "public"."profile_access" add constraint "profile_access_user_id_fkey" FOREIGN KEY (user_id) REFERENCES users(id) not valid;

alter table "public"."profile_access" validate constraint "profile_access_user_id_fkey";

grant delete on table "public"."profile_access" to "anon";

grant insert on table "public"."profile_access" to "anon";

grant references on table "public"."profile_access" to "anon";

grant select on table "public"."profile_access" to "anon";

grant trigger on table "public"."profile_access" to "anon";

grant truncate on table "public"."profile_access" to "anon";

grant update on table "public"."profile_access" to "anon";

grant delete on table "public"."profile_access" to "authenticated";

grant insert on table "public"."profile_access" to "authenticated";

grant references on table "public"."profile_access" to "authenticated";

grant select on table "public"."profile_access" to "authenticated";

grant trigger on table "public"."profile_access" to "authenticated";

grant truncate on table "public"."profile_access" to "authenticated";

grant update on table "public"."profile_access" to "authenticated";

grant delete on table "public"."profile_access" to "service_role";

grant insert on table "public"."profile_access" to "service_role";

grant references on table "public"."profile_access" to "service_role";

grant select on table "public"."profile_access" to "service_role";

grant trigger on table "public"."profile_access" to "service_role";

grant truncate on table "public"."profile_access" to "service_role";

grant update on table "public"."profile_access" to "service_role";


