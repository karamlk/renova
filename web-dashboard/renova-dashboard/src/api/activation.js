import api from "./axios";

export async function editActivationRequest(id) {
  let response = await api.patch(`/admin/users/${id}/active`);
  return response;
}
