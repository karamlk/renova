import api from "./axios";
/////////////////////////////////
export async function getFinanceRequest() {
  let response = await api.get("/admin/finance/dashboard");
  return response;
}
export async function getWaitingReleaseRequest() {
  let response = await api.get("/admin/projects/waiting-release");
  return response;
}
export async function transferMoneyRequest(id, amount) {
  let response = await api.post(`/admin/payments/${id}/release`, { amount });
  return response;
}
/////////////////////////////////
export async function getUserPaymentRequest() {
  let response = await api.get("/admin/payments");
  return response;
}
export async function showUserPaymentRequest(id) {
  let response = await api.get(`/admin/payments/${id}`);
  return response;
}
////////////////////////////////
export async function getpaymentLogsRequest() {
  let response = await api.get("/admin/payment-audits");
  return response;
}
export async function getFilterPaymentLogsRequest(filters = {}) {
  let response = await api.get("/admin/payment-audits", {
    params: filters,
  });
  return response;
}
export async function showPaymentLogsRequest(id) {
  let response = await api.get(`/admin/payment-audits/${id}`);
  return response;
}
