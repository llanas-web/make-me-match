create type "public"."photos_status" as enum ('pending', 'accepted', 'rejected');

drop policy "Enable users to view their own data only" on "public"."photos";

alter table "public"."photos" add column "status" photos_status not null default 'pending'::photos_status;

create policy "Enable users to view their own data only"
on "public"."photos"
as permissive
for select
to authenticated
using (((( SELECT auth.uid() AS uid) = profile_id) OR (( SELECT auth.uid() AS uid) = uploaded_by) OR (is_user_allow_profile(auth.uid(), profile_id) AND (status = 'accepted'::photos_status))));



