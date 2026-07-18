import api from "./axios";

export async function getUsersRequest() {
  let response = await api.get("/admin/users");
  return response;
}

export async function getFilterUsersRequest(type) {
  let response = await api.get(`/admin/${type}`);
  return response;
}

export async function createUserRequest(
  name,
  email,
  password,
  password_confirmation,
) {
  let response = await api.post("/admin/create-engineer", {
    name,
    email,
    password,
    password_confirmation,
  });
  return response;
}

export async function getUserProfileRequest(id) {
  let response = await api.get(`/admin/users/${id}`);
  return response;
}

export async function deleteUserRequest(id) {
  let response = await api.delete(`/admin/users/${id}`);
  return response;
}
