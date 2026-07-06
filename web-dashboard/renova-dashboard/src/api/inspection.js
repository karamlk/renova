import api from "./axios";

export async function getInspectionRequest() {
  let response = await api.get("/admin/site-visits/pending-assignment");
  return response;
}

export async function getEngineersRequest() {
  let response = await api.get("/admin/available-engineers");
  return response;
}

export async function chooseEngineerRequest(visit_id, engineer_id) {
  let response = await api.post("/admin/site-visits/assign", {
    visit_id,
    engineer_id,
  });
  return response;
}
