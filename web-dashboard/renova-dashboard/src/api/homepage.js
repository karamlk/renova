import api from "./axios";
export async function getDashboardRequest() {
  let response = await api.get("/admin/analytics/summary");
  return response;
}
