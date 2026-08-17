import api from "./axios";

export async function getVerificationRequest() {
  let response = await api.get("/admin/foundations/verification/pending");
  return response;
}
export async function approveFoundationRequest(id) {
  let response = await api.post(`/admin/foundations/${id}/approve`);
  return response;
}
export async function rejectFoundationRequest(id) {
  let response = await api.post(`/admin/foundations/${id}/reject`);
  return response;
}
