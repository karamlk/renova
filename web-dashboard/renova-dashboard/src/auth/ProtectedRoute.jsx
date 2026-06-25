import { Navigate, Outlet } from "react-router-dom";

export default function ProtectedRoute() {
  const token = localStorage.getItem("token");
  const role = localStorage.getItem("role");

  if (!token || role !== "admin") {
    return <Navigate to="/" replace />;
  }

  return <Outlet />;
}