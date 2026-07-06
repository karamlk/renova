import "./Topbar.css";
//Hooks
import { useState,useContext } from "react";
import { useTranslation } from 'react-i18next';
//Commponents
import Profiledialog from "../Profiledialog/Profiledialog";
//MUI Icons
import NotificationsIcon from '@mui/icons-material/Notifications';
import Avatar from '@mui/material/Avatar';
import AccountCircleIcon from '@mui/icons-material/AccountCircle';
//Context
import {UserContext} from "../../Context/UserContext";
export default function Topbar() {
    const [t]=useTranslation();
    const [showprofile, setshowprofile] = useState(false);
    const {user}=useContext(UserContext);
    let role ={ 1:"مدير النظام", 2:"مستخدم", 3:"متعهد", 4:"مهندس"}
    return (  
    <div className="top-bar">
        {showprofile && (<Profiledialog
         name={user?.name}
         first_name={user?.profile?.first_name}
         last_name={user?.profile?.last_name}
         image={user?.profile?.full_image_url ? <Avatar  src={user?.profile?.full_image_url} alt="img" sx={{ width: 80, height: 80 }} /> :<AccountCircleIcon  sx={{ color: '#f07c1f' ,fontSize:"80px" }} />}
         email={user?.email}
         phone={user?.profile?.phone}
         location={user?.profile?.location}
         role={role[user?.role_id]}
         onClose={() => setshowprofile(false)}
          />)}
            <div className="title">
                <h1>{t("مرحباً،")} <span>{user?.profile?.first_name + " " +user?.profile?.last_name}</span></h1>
                <p>{t("نظرة عامة على أداء نظام إعادة الإعمار")}</p>
            </div>
            <div className="user-section">
                <div className="notification">
                    <NotificationsIcon fontSize="medium"/>
                    <div className="notification-badge">3</div>
                </div>
                <div className="user-card" onClick={() => setshowprofile(true)} >
                   {user?.profile?.full_image_url ? <Avatar  src={user?.profile?.full_image_url} alt="img" sx={{ width: 35, height: 35 }} /> :<AccountCircleIcon  sx={{ color: '#f07c1f' ,fontSize:"80px" }} />}
                    <span>{user?.profile?.first_name + " " + user?.profile?.last_name}</span>
                </div>
            </div>
        </div>
        );
    
}