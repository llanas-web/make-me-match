alter table "public"."profile_access" drop constraint "profile_access_profile_id_fkey";

alter table "public"."profile_access" drop constraint "profile_access_user_id_fkey";

alter table "public"."profiles" drop constraint "profiles_id_fkey";

alter table "public"."users" drop constraint "users_id_fkey";

alter table "public"."profile_access" add constraint "profile_access_profile_id_fkey" FOREIGN KEY (profile_id) REFERENCES profiles(id) ON UPDATE CASCADE ON DELETE CASCADE not valid;

alter table "public"."profile_access" validate constraint "profile_access_profile_id_fkey";

alter table "public"."profile_access" add constraint "profile_access_user_id_fkey" FOREIGN KEY (user_id) REFERENCES users(id) ON UPDATE CASCADE ON DELETE CASCADE not valid;

alter table "public"."profile_access" validate constraint "profile_access_user_id_fkey";

alter table "public"."profiles" add constraint "profiles_id_fkey" FOREIGN KEY (id) REFERENCES users(id) ON UPDATE CASCADE ON DELETE CASCADE not valid;

alter table "public"."profiles" validate constraint "profiles_id_fkey";

alter table "public"."users" add constraint "users_id_fkey" FOREIGN KEY (id) REFERENCES auth.users(id) ON UPDATE CASCADE ON DELETE CASCADE not valid;

alter table "public"."users" validate constraint "users_id_fkey";


