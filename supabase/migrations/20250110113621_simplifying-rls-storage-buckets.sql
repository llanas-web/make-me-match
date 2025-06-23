drop policy "Allow select for own profile or user_id" on "public"."profile_access";

drop policy "Allow update to own user" on "public"."profiles";

drop policy "Enable insert for users based on id" on "public"."profiles";

drop policy "Enable user to view their own data" on "public"."users";

set check_function_bodies = off;

CREATE OR REPLACE FUNCTION public.is_user_allow_profile(_user_id uuid, _profile_id uuid)
 RETURNS boolean
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$BEGIN
  RAISE LOG 'Calling is_user_allow_profile(user_id: %, profile_id: %)', _user_id, _profile_id;
  RETURN EXISTS(SELECT 1 FROM public.profile_access WHERE (profile_access.user_id = _user_id AND profile_access.profile_id = _profile_id)
  );
END;$function$
;

create policy "Allow select for own profile or user_id"
on "public"."profile_access"
as permissive
for select
to authenticated
using (((auth.uid() = profile_id) OR (auth.uid() = user_id)));


create policy "Allow update to own user"
on "public"."profiles"
as permissive
for update
to authenticated
using ((auth.uid() = id));


create policy "Enable insert for users based on id"
on "public"."profiles"
as permissive
for insert
to authenticated
with check ((auth.uid() = id));


create policy "Enable user to view their own data"
on "public"."users"
as permissive
for select
to authenticated
using (((auth.uid() = id) OR is_user_allow_profile(auth.uid(), id) OR (EXISTS ( SELECT 1
   FROM profile_access
  WHERE ((profile_access.user_id = users.id) AND (profile_access.profile_id = auth.uid()))))));



