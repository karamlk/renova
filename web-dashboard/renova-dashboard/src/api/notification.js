import api from "./axios";
export async function getNotificationListRequest(pageNumber = 1) {
  let response = await api.get(`/notifications?page=${pageNumber}`);
  return response;
}
export async function getNotificationCountRequest() {
  let response = await api.get("/notifications/unread-count");
  return response;
}
export async function readNotificationRequest(id) {
  let response = await api.patch(`/notifications/${id}/read`);
  return response;
}
export async function allReadNotificationRequest() {
  let response = await api.patch(`/notifications/read-all`);
  return response;
}
export async function deleteNotificationRequest() {
  let response = await api.delete(`/notifications`);
  return response;
}
