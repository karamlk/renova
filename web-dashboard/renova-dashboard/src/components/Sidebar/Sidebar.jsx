import "./Sidebar.css";
import { NavLink } from "react-router-dom";
import { LoadingContext } from "../../Context/Loadingcontext";
import{useContext} from "react";
import { useNavigate } from "react-router-dom";
// Material UI Icons
import HomeIcon from '@mui/icons-material/Home';
import SettingsIcon from '@mui/icons-material/Settings';
import GroupIcon from '@mui/icons-material/Group';
import LogoutIcon from '@mui/icons-material/Logout';
export default function Sidebar() {
 const {setisloading}=useContext(LoadingContext);
 const navigate = useNavigate();
 function LoadingPage() {
     setisloading(true);
    setTimeout(() => {setisloading(false)},1500)
 }
 function RemoveStorge() {
     localStorage.removeItem("token");
     localStorage.removeItem("role");
     navigate("/", { replace: true });
 }
    return (  
          <div className="sidebar">
        <div className="sidebar-header">
                    <img src="/assets/images/logo.png" alt="Logo" width="78" height="78" />
                <div className="logo-text">
                    <h2>ري<span>ن</span>وفا</h2>
                    <p>نظام إعادة الإعمار الذكي</p>
                </div>
        </div>
        <div className="sidebar-menu">
            <NavLink onClick={LoadingPage} to="homepage" className={({ isActive }) => isActive ? "menu-btn active" : "menu-btn"} >
                <HomeIcon />
                <span>الصفحة الرئيسية</span>
            </NavLink>

            <NavLink onClick={LoadingPage} to="users" className={({ isActive }) => isActive ? "menu-btn active" : "menu-btn"} >
                <GroupIcon />
                <span>المستخدمين</span>
            </NavLink>

            <NavLink onClick={LoadingPage} to="settings" className={({ isActive }) => isActive ? "menu-btn active" : "menu-btn"} >
                <SettingsIcon />
                <span>الإعدادات</span>
            </NavLink>

            <div onClick={RemoveStorge} className="menu-btn-logout" >
                <LogoutIcon />
                <span>تسجيل خروج</span>
            </div>
        </div>
    </div>
    );
}