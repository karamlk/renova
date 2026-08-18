import api from "./axios";

export async function getProjectsRequest() {
  let response = await api.get("/admin/projects");
  return response;
}
export async function showProjectRequest(id) {
  let response = await api.get(`/admin/project/${id}`);
  return response;
}
export async function archiveProjectRequest(id) {
  let response = await api.patch(`/admin/projects/${id}/archive`);
  return response;
}
export async function restoreProjectRequest(id) {
  let response = await api.patch(`/admin/projects/${id}/restore`);
  return response;
}
export async function getArchivedProjectsRequest() {
  let response = await api.get("/admin/projects/archived");
  return response;
}
export async function showArchivedProjectRequest(id) {
  let response = await api.get(`/admin/projects/archived/${id}`);
  return response;
}
