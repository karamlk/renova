import api from "./axios";
export async function getNotificationListRequest(pageNumber = 1) {
  let response = await api.get(`/admin/notifications?page=${pageNumber}`);
  return response;
}
export async function getNotificationCountRequest() {
  let response = await api.get("/admin/notifications/unread-count");
  return response;
}
export async function readNotificationRequest(id) {
  let response = await api.patch(`/admin/notifications/${id}/read`);
  return response;
}
export async function allReadNotificationRequest() {
  let response = await api.patch(`/admin/notifications/read-all`);
  return response;
}
export async function deleteNotificationRequest() {
  let response = await api.delete(`/admin/notifications`);
  return response;
}
