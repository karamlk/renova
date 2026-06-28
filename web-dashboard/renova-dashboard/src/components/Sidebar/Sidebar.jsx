import "./Sidebar.css";
//Components
import Langswitcher from "../Langswitcher/Langswitcher";
//Router
import { NavLink } from "react-router-dom";

import { useNavigate } from "react-router-dom";
import { useTranslation } from 'react-i18next';
// Material UI Icons
import HomeIcon from '@mui/icons-material/Home';
import GroupIcon from '@mui/icons-material/Group';
import LogoutIcon from '@mui/icons-material/Logout';

export default function Sidebar() {

 const navigate = useNavigate();
 const [t]=useTranslation();

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
                    <h2>{t("ري")}<span>{t("ن")}</span>{t("وفا")}</h2>
                    <p>{t("نظام إعادة الإعمار الذكي")}</p>
                </div>
        </div>
        <div className="sidebar-menu">
            <NavLink  to="homepage" className={({ isActive }) => isActive ? "menu-btn active" : "menu-btn"} >
                <HomeIcon />
                <span>{t("الصفحة الرئيسية")}</span>
            </NavLink>

            <NavLink  to="users" className={({ isActive }) => isActive ? "menu-btn active" : "menu-btn"} >
                <GroupIcon />
                <span>{t("المستخدمين")}</span>
            </NavLink>
         
            <div onClick={RemoveStorge} className="menu-btn-logout" >
                <LogoutIcon />
                <span>{t("تسجيل خروج")}</span>
            </div>
           
        </div>
         <div className="sidebar-language">
                <Langswitcher/>
            </div>
    </div>
    );
}