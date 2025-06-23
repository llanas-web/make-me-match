drop policy "Enable user to view their own data" on "public"."users";

create policy "Allow select for own profile or user_id"
on "public"."profile_access"
as permissive
for select
to authenticated
using (((( SELECT auth.uid() AS uid) = profile_id) OR (( SELECT auth.uid() AS uid) = user_id)));


create policy "Enable user to view their own data"
on "public"."users"
as permissive
for select
to authenticated
using (((( SELECT auth.uid() AS uid) = id) OR is_user_allow_profile(auth.uid(), id) OR is_user_allow_profile(id, auth.uid())));



