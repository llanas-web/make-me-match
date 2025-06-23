create table "public"."sub_profile" (
    "profile_id" uuid not null default gen_random_uuid(),
    "created_at" timestamp with time zone not null default now(),
    "user_id" uuid not null default gen_random_uuid(),
    "updated_at" timestamp with time zone not null default now(),
    "oredered_photos" uuid[] not null default '{}'::uuid[]
);


alter table "public"."sub_profile" enable row level security;

alter table "public"."profiles" add column "metadata" uuid[] not null;

CREATE UNIQUE INDEX sub_profile_pkey ON public.sub_profile USING btree (profile_id, user_id);

alter table "public"."sub_profile" add constraint "sub_profile_pkey" PRIMARY KEY using index "sub_profile_pkey";

alter table "public"."sub_profile" add constraint "sub_profile_profile_id_fkey" FOREIGN KEY (profile_id) REFERENCES profiles(id) ON UPDATE CASCADE ON DELETE CASCADE not valid;

alter table "public"."sub_profile" validate constraint "sub_profile_profile_id_fkey";

alter table "public"."sub_profile" add constraint "sub_profile_user_id_fkey" FOREIGN KEY (user_id) REFERENCES users(id) ON UPDATE CASCADE ON DELETE CASCADE not valid;

alter table "public"."sub_profile" validate constraint "sub_profile_user_id_fkey";

grant delete on table "public"."sub_profile" to "anon";

grant insert on table "public"."sub_profile" to "anon";

grant references on table "public"."sub_profile" to "anon";

grant select on table "public"."sub_profile" to "anon";

grant trigger on table "public"."sub_profile" to "anon";

grant truncate on table "public"."sub_profile" to "anon";

grant update on table "public"."sub_profile" to "anon";

grant delete on table "public"."sub_profile" to "authenticated";

grant insert on table "public"."sub_profile" to "authenticated";

grant references on table "public"."sub_profile" to "authenticated";

grant select on table "public"."sub_profile" to "authenticated";

grant trigger on table "public"."sub_profile" to "authenticated";

grant truncate on table "public"."sub_profile" to "authenticated";

grant update on table "public"."sub_profile" to "authenticated";

grant delete on table "public"."sub_profile" to "service_role";

grant insert on table "public"."sub_profile" to "service_role";

grant references on table "public"."sub_profile" to "service_role";

grant select on table "public"."sub_profile" to "service_role";

grant trigger on table "public"."sub_profile" to "service_role";

grant truncate on table "public"."sub_profile" to "service_role";

grant update on table "public"."sub_profile" to "service_role";


