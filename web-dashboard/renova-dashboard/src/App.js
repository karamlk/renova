//Routes
import { Routes, Route, Navigate } from "react-router-dom";
import Dashboard from "./pages/Dashboard/Dashboard";
import Login from "./pages/Login/Login";
import Homepage from "./pages/Homepage/Homepage";
import Usersettings from "./pages/Usersettings/Usersettings";
import Users from "./pages/Users/Users";
import Requests from "./pages/Requests/Requests";
import Inspectionrequests from "./pages/Inspectionrequests/Inspectionrequests";
import Complaints from "./pages/Complaints/Complaints";
//auth
import ProtectedRoute from "./auth/ProtectedRoute";
import AuthGate from "./auth/AuthGate";
//Context
import { LoadingContext } from "./Context/Loadingcontext";
import UserProvider from "./Context/UserContext";

//Hooks
import { useState } from "react";
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
      <UserProvider>
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
                <Route path="requests" element={<Requests />} />
                <Route path="Complaints" element={<Complaints />} />
                <Route
                  path="inspections_requests"
                  element={<Inspectionrequests />}
                />
                <Route path="usersettings" element={<Usersettings />} />
              </Route>
            </Route>
          </Routes>
        </div>
      </UserProvider>
    </LoadingContext.Provider>
  );
}

export default App;
