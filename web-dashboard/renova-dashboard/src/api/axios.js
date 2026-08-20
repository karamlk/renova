import axios from "axios";
import { loginRequest } from "./auth";
const api = axios.create({
  baseURL: "http://192.168.137.63:8000/api",
  headers: {
    Accept: "application/json",
  },
});

api.interceptors.request.use((config) => {
  const token = localStorage.getItem("token");

  if (token) {
    config.headers.Authorization = `Bearer ${token}`;
  }

  return config;
});

api.interceptors.response.use(
  (response) => response,

  (error) => {
    const isLoginRequest = error.config?.url === "/login";
    if (error.response?.status === 401 && !isLoginRequest) {
      localStorage.removeItem("token");
      localStorage.removeItem("role");

      window.location.href = "/";
    }

    return Promise.reject(error);
  },
);

export default api;
