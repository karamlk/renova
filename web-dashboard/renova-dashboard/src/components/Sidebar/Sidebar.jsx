import "./Sidebar.css";
import Langswitcher from "../Langswitcher/Langswitcher";
import { NavLink } from "react-router-dom";
import { LoadingContext } from "../../Context/Loadingcontext";
import{useContext} from "react";
import { useNavigate } from "react-router-dom";
import { useTranslation } from 'react-i18next';
// Material UI Icons
import HomeIcon from '@mui/icons-material/Home';
import SettingsIcon from '@mui/icons-material/Settings';
import GroupIcon from '@mui/icons-material/Group';
import LogoutIcon from '@mui/icons-material/Logout';
export default function Sidebar() {
 const {setisloading}=useContext(LoadingContext);
 const navigate = useNavigate();
 const [t]=useTranslation();
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
                    <h2>{t("ري")}<span>{t("ن")}</span>{t("وفا")}</h2>
                    <p>{t("نظام إعادة الإعمار الذكي")}</p>
                </div>
        </div>
        <div className="sidebar-menu">
            <NavLink onClick={LoadingPage} to="homepage" className={({ isActive }) => isActive ? "menu-btn active" : "menu-btn"} >
                <HomeIcon />
                <span>{t("الصفحة الرئيسية")}</span>
            </NavLink>

            <NavLink onClick={LoadingPage} to="users" className={({ isActive }) => isActive ? "menu-btn active" : "menu-btn"} >
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