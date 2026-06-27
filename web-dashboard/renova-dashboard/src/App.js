import Dashboard from "./pages/Dashboard/Dashboard";
import Login from "./pages/Login/Login";

import ProtectedRoute from "./auth/ProtectedRoute";
import AuthGate from "./auth/AuthGate";
import { Routes, Route, Navigate } from "react-router-dom";
import { LoadingContext } from "./Context/Loadingcontext";
import { useState } from "react";
import Homepage from "./pages/Homepage/Homepage";
import Settings from "./pages/Settings/Settings";
import Users from "./pages/Users/Users";

import { useEffect } from "react";
import { useTranslation } from "react-i18next";
function App() {
  let [isloading, setisloading] = useState(false);
  const { i18n } = useTranslation();

  useEffect(() => {
    const dir = i18n.dir(); // "rtl" or "ltr"
    document.documentElement.setAttribute("dir", dir);
  }, [i18n.language]);

  return (
    <LoadingContext.Provider value={{ isloading, setisloading }}>
      <div className="App">
        <Routes>
          <Route
            path="/"
            element={
              <AuthGate>
                <Login />
              </AuthGate>
            }
          />

          <Route element={<ProtectedRoute />}>
            <Route path="/dashboard" element={<Dashboard />}>
              <Route index element={<Navigate to="homepage" replace />} />
              <Route path="homepage" element={<Homepage />} />
              <Route path="users" element={<Users />} />
              <Route path="settings" element={<Settings />} />
            </Route>
          </Route>
        </Routes>
      </div>
    </LoadingContext.Provider>
  );
}

export default App;
