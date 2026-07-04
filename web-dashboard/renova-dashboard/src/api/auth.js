import api from "./axios";

export async function loginRequest(email, password) {
  let response = await api.post("/login", {
    email,
    password,
  });
  return response;
}

export async function getProfileRequest() {
  let response = await api.get("/user/profile");
  return response;
}

export function logoutRequest(navigate) {
  localStorage.removeItem("token");
  localStorage.removeItem("role");
  navigate("/", { replace: true });
}
