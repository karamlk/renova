import "./Sidebar.css";
//Components
import Langswitcher from "../Langswitcher/Langswitcher";
import SidebarBtn from "../SidebarBtn/SidebarBtn";
//Hooks
import { useNavigate } from "react-router-dom";
import { useTranslation } from 'react-i18next';
// MUI 
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
import FindInPageIcon from '@mui/icons-material/FindInPage';
import VerifiedUserIcon from '@mui/icons-material/VerifiedUser';
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
        <div className="sidebar-body">

            <SidebarBtn icon={<HomeIcon sx={{fontSize: "25px"}}/>} text="الصفحة الرئيسية" link="homepage"/>
            <SidebarBtn icon={<ApartmentIcon sx={{fontSize: "25px"}}/>} text="المشاريع" link="Construction_projects"/> 
            <SidebarBtn icon={<GroupIcon sx={{fontSize: "25px"}}/>} text="المستخدمين" link="users"/>

            <div className="container">
                <div className="list-btn">
                        <div className="list-title-btn">
                            <AssignmentIcon />
                            <span>{t("الطلبات")}</span>
                        </div>
                        <div className="arrow">
                            <ArrowDropDownIcon/>
                        </div>
                </div>
                <div className="list-dropdown">
                    <SidebarBtn icon={<AccessTimeFilledIcon sx={{fontSize: "25px"}}/>} text="طلبات المتعهدين" link="requests" className="dropdown-item"/>
                    <SidebarBtn icon={<FindInPageIcon sx={{fontSize: "25px"}}/>} text="طلبات المعاينة" link="inspection_requests" className="dropdown-item"/>
                    <SidebarBtn icon={<VerifiedUserIcon sx={{fontSize: "25px"}}/>} text="طلبات التوثيق" link="verification_requests" className="dropdown-item"/>
                </div>
            </div>

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
                    <SidebarBtn icon={<CurrencyExchangeIcon sx={{fontSize: "20px"}}/>} text="التحويلات المالية" link="moneytransfers" className="dropdown-item"/>
                    <SidebarBtn icon={<ReceiptLongIcon sx={{fontSize: "20px"}} />} text="دفعات المستخدمين" link="userpayments" className="dropdown-item"/>
                    <SidebarBtn icon={<HistoryIcon sx={{fontSize: "20px"}} />} text="سجل الدفعات" link="Financiallogs" className="dropdown-item"/>
                </div>
            </div>

            <SidebarBtn icon={<FeedbackIcon sx={{fontSize: "25px"}}/>} text="شكاوى المستخدمين" link="complaints"/>

            <div className="container">
                <div className="list-btn">
                        <div className="list-title-btn">
                            <ArchiveIcon sx={{fontSize: "25px"}} />
                            <span>{t("الأرشيف")}</span>
                        </div>
                        <div className="arrow">
                            <ArrowDropDownIcon/>
                        </div>
                </div>
                <div className="list-dropdown">
                    <SidebarBtn icon={<ApartmentIcon sx={{fontSize: "20px"}}/>} text="أرشيف المشاريع" link="projectsarchive" className="dropdown-item"/>
                    <SidebarBtn icon={<ModeCommentIcon sx={{fontSize: "20px"}} />} text="أرشيف الشكاوى" link="complaintsarchive" className="dropdown-item"/>
                </div>
            </div>

            <SidebarBtn icon={<SettingsIcon sx={{fontSize: "25px"}}/>} text="إعدادات الحساب" link="usersettings"/>

            <div onClick={Logout} className="menu-btn-logout" >
                <LogoutIcon sx={{fontSize: "25px"}}/>
                <span>{t("تسجيل خروج")}</span>
            </div>
        </div>
        <div className="sidebar-footer">
                <Langswitcher/>
        </div>
    </div>
    );
}