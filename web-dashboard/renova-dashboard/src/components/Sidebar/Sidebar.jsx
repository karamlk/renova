import "./Sidebar.css";
//Components
import Langswitcher from "../Langswitcher/Langswitcher";
//Router
import { NavLink } from "react-router-dom";
//Hooks
import { useNavigate } from "react-router-dom";
import { useTranslation } from 'react-i18next';
// Material UI Icons
import HomeIcon from '@mui/icons-material/Home';
import GroupIcon from '@mui/icons-material/Group';
import LogoutIcon from '@mui/icons-material/Logout';
import AccessTimeFilledIcon from '@mui/icons-material/AccessTimeFilled';
import SettingsIcon from '@mui/icons-material/Settings';
import AssignmentIcon from '@mui/icons-material/Assignment';
import FeedbackIcon from '@mui/icons-material/Feedback';
import ArchiveIcon from '@mui/icons-material/Archive';
import ApartmentIcon from '@mui/icons-material/Apartment';
import ArrowDropDownIcon from '@mui/icons-material/ArrowDropDown';
import ModeCommentIcon from '@mui/icons-material/ModeComment';
import AccountBalanceWalletIcon from '@mui/icons-material/AccountBalanceWallet';
import CurrencyExchangeIcon from '@mui/icons-material/CurrencyExchange';
import ReceiptLongIcon from '@mui/icons-material/ReceiptLong';
import HistoryIcon from '@mui/icons-material/History';
//api
import {logoutRequest} from "../../api/auth";

export default function Sidebar() {

 const navigate = useNavigate();
 const [t]=useTranslation();

 function Logout() {
     logoutRequest(navigate);
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
            {/*
            <NavLink  to="projects" className={({ isActive }) => isActive ? "menu-btn active" : "menu-btn"} >
                <ApartmentIcon />
                <span>{t("المشاريع")}</span>
            </NavLink>
            */}
            <NavLink  to="users" className={({ isActive }) => isActive ? "menu-btn active" : "menu-btn"} >
                <GroupIcon />
                <span>{t("المستخدمين")}</span>
            </NavLink>

            <NavLink  to="requests" className={({ isActive }) => isActive ? "menu-btn active" : "menu-btn"} >
                <AccessTimeFilledIcon />
                <span>{t("طلبات المتعهدين")}</span>
            </NavLink>

            <NavLink  to="inspections_requests" className={({ isActive }) => isActive ? "menu-btn active" : "menu-btn"} >
                <AssignmentIcon />
                <span>{t("طلبات المعاينة")}</span>
            </NavLink>

            <div className="container">
                <div className="list-btn">
                        <div className="list-title-btn">
                            <AccountBalanceWalletIcon />
                            <span>{t("المالية")}</span>
                        </div>
                        <div className="arrow">
                            <ArrowDropDownIcon/>
                        </div>
                </div>
                <div className="list-dropdown">
                    <NavLink to="moneytransfers" className={({ isActive }) => isActive ? "dropdown-item active" : "dropdown-item"}>
                        <CurrencyExchangeIcon sx={{fontSize: "20px"}}/>
                        <span>{t("التحويلات المالية")}</span>
                    </NavLink>

                    <NavLink to="userpayments" className={({ isActive }) => isActive ? "dropdown-item active" : "dropdown-item"}>
                        <ReceiptLongIcon sx={{fontSize: "23px"}} />
                        <span>{t("دفعات المستخدمين")}</span>
                    </NavLink>

                    <NavLink to="Financiallogs" className={({ isActive }) => isActive ? "dropdown-item active" : "dropdown-item"}>
                        <HistoryIcon sx={{fontSize: "25px"}} />
                        <span>{t("سجل الدفعات")}</span>
                    </NavLink>
                </div>
            </div>

            <NavLink  to="complaints" className={({ isActive }) => isActive ? "menu-btn active" : "menu-btn"} >
                <FeedbackIcon />
                <span>{t("شكاوى المستخدمين")}</span>
            </NavLink>
                
            <div className="container">
                <div className="list-btn">
                        <div className="list-title-btn">
                            <ArchiveIcon />
                            <span>{t("الأرشيف")}</span>
                        </div>
                        <div className="arrow">
                            <ArrowDropDownIcon/>
                        </div>
                </div>
                <div className="list-dropdown">
                    {/*
                    <NavLink to="projectsarchive" className={({ isActive }) => isActive ? "dropdown-item active" : "dropdown-item"}>
                        <ApartmentIcon />
                        <span>{t("أرشيف المشاريع")}</span>
                    </NavLink>

                    */}
                    <NavLink to="complaintsarchive" className={({ isActive }) => isActive ? "dropdown-item active" : "dropdown-item"}>
                        <ModeCommentIcon sx={{fontSize: "21px"}} />
                        <span>{t("أرشيف الشكاوى")}</span>
                    </NavLink>
                </div>
            </div>



            <NavLink  to="usersettings" className={({ isActive }) => isActive ? "menu-btn active" : "menu-btn"} >
                <SettingsIcon />
                <span>{t("إعدادات الحساب")}</span>
            </NavLink>

            <div onClick={Logout} className="menu-btn-logout" >
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