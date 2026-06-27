import "./Topbar.css";
import { getProfileRequest } from "../../api/auth";
import { useState,useEffect } from "react";
import { useTranslation } from 'react-i18next';
import Profiledialog from "../Profiledialog/Profiledialog";
import Avatar from '@mui/material/Avatar';
//// Material UI Icons
import NotificationsIcon from '@mui/icons-material/Notifications';
import AccountCircleIcon from '@mui/icons-material/AccountCircle';
export default function Topbar() {
    const [t]=useTranslation();
    const [showprofile, setshowprofile] = useState(false);
    const[profile,setprofile]=useState({});
    useEffect(()=>{
        async function loadProfile() {
            let response = await getProfileRequest();
            setprofile(response.data);
            
        }
        loadProfile();
    },[]);
    return (
        
    <div className="top-bar">
        {showprofile && (<Profiledialog onClose={() => setshowprofile(false)} />)}
            <div className="title">
                <h1>{t("مرحباً،")} <span>{profile?.data?.profile?.first_name + " " + profile?.data?.profile?.last_name}</span></h1>
                <p>{t("نظرة عامة على أداء نظام إعادة الإعمار")}</p>
            </div>
            <div className="user-section">
                <div className="notification">
                    <NotificationsIcon fontSize="medium"/>
                    <div className="notification-badge">3</div>
                </div>
                <div className="user-card" onClick={() => setshowprofile(true)} >
                   {profile?.data?.profile?.full_image_url ? <Avatar  src={profile?.data?.profile?.full_image_url} alt="img" sx={{ width: 35, height: 35 }} /> :<AccountCircleIcon fontSize="large" sx={{ color: '#f07c1f' }} />}
                    <span>{profile?.data?.profile?.first_name + " " + profile?.data?.profile?.last_name}</span>
                </div>
            </div>
        </div>
        );
    
}