import { Navigate } from "react-router-dom";

export default function AuthGate({ children }) {
  const token = localStorage.getItem("token");
  const role = localStorage.getItem("role");

  if (token && role === "admin") {
    return <Navigate to="/dashboard" replace />;
  }

  return children;
}