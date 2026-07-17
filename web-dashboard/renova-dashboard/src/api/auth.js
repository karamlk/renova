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

export async function updateProfileRequest(data) {
  let response = await api.post("/user/profile/update", data);
  return response;
}

export async function updatePasswordRequest(
  current_password,
  new_password,
  new_password_confirmation,
) {
  let response = await api.post("/password/change", {
    current_password,
    new_password,
    new_password_confirmation,
  });
  return response;
}
export function logoutRequest(navigate) {
  localStorage.removeItem("token");
  localStorage.removeItem("role");
  navigate("/", { replace: true });
}
