drop policy "Enable users to view their own data only" on "public"."profiles";

drop policy "Enable users to view their own data only" on "public"."photos";

drop policy "Enable user to view their own data" on "public"."users";

set check_function_bodies = off;

CREATE OR REPLACE FUNCTION public.is_user_allow_profile(_user_id uuid, _profile_id uuid)
 RETURNS boolean
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$BEGIN
  RETURN EXISTS(SELECT 1 FROM public.profile_access WHERE (profile_access.user_id = _user_id AND profile_access.profile_id = _profile_id)
  );
END;$function$
;

create policy "Enable users to view their own data or their accessible data"
on "public"."profiles"
as permissive
for select
to authenticated
using (((id = auth.uid()) OR is_user_allow_profile(auth.uid(), id)));


create policy "Enable users to view their own data only"
on "public"."photos"
as permissive
for select
to authenticated
using (((( SELECT auth.uid() AS uid) = profile_id) OR (( SELECT auth.uid() AS uid) = uploaded_by) OR is_user_allow_profile(auth.uid(), profile_id)));


create policy "Enable user to view their own data"
on "public"."users"
as permissive
for select
to authenticated
using (((( SELECT auth.uid() AS uid) = id) OR is_user_allow_profile(auth.uid(), id)));



