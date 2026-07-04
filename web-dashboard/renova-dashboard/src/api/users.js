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
