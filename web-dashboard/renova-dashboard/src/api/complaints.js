import api from "./axios";
export async function getComplaintsRequest() {
  let response = await api.get("/admin/all-complaints");
  return response;
}
export async function getFilterComplaintsRequest(filters = {}) {
  let response = await api.get("/admin/all-complaints", {
    params: filters,
  });
  return response;
}
export async function patchComplaintRequest(
  id,
  status,
  admin_processing_note,
  penalty_percentage,
) {
  let response = await api.patch(`admin/complaints/${id}/resolve`, {
    status,
    admin_processing_note,
    penalty_percentage,
  });
  return response;
}
