create policy "Give auth users insert access to user_avatar bucket"
on "storage"."objects"
as permissive
for insert
to authenticated
with check ((bucket_id = 'user_avatar'::text));


create policy "Give auth users select access to user_avatar bucket"
on "storage"."objects"
as permissive
for select
to authenticated
using ((bucket_id = 'user_avatar'::text));


create policy "Give users access to own or allowed folder"
on "storage"."objects"
as permissive
for select
to authenticated
using (((bucket_id = 'profile_photos'::text) AND ((auth.uid() = ((storage.foldername(name))[1])::uuid) OR (auth.uid() = (owner_id)::uuid) OR is_user_allow_profile(auth.uid(), ((storage.foldername(name))[1])::uuid))));


create policy "Give users delete access to own avatar"
on "storage"."objects"
as permissive
for delete
to authenticated
using (((bucket_id = 'user_avatar'::text) AND (auth.uid() = (owner_id)::uuid)));


create policy "Give users delete access to own folder"
on "storage"."objects"
as permissive
for delete
to authenticated
using (((bucket_id = 'profile_photos'::text) AND (auth.uid() = ((storage.foldername(name))[1])::uuid)));


create policy "Give users insert access to own or allowed folder"
on "storage"."objects"
as permissive
for insert
to authenticated
with check ((((bucket_id = 'profile_photos'::text) AND (auth.uid() = ((storage.foldername(name))[1])::uuid)) OR is_user_allow_profile(auth.uid(), ((storage.foldername(name))[1])::uuid)));


create policy "Give users update access to own avatar"
on "storage"."objects"
as permissive
for update
to authenticated
using (((bucket_id = 'user_avatar'::text) AND (auth.uid() = (owner_id)::uuid)));


create policy "Give users update access to own folder"
on "storage"."objects"
as permissive
for update
to authenticated
using (((bucket_id = 'profile_photos'::text) AND (auth.uid() = ((storage.foldername(name))[1])::uuid)));



