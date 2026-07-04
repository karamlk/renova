import api from "./axios";

export async function getContractorsRequest() {
  let response = await api.get("/admin/contractors/pending");
  return response;
}

export async function approveContractorRequest(id) {
  let response = await api.post(`/admin/contractors/${id}/approve`);
  return response;
}

export async function rejectContractorRequest(id) {
  let response = await api.post(`/admin/contractors/${id}/reject`);
  return response;
}
