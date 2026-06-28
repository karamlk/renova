import "./Topbar.css";
//Hooks
import { useState,useEffect } from "react";
import { useTranslation } from 'react-i18next';
//Commponents
import Profiledialog from "../Profiledialog/Profiledialog";
//MUI Icons
import NotificationsIcon from '@mui/icons-material/Notifications';
import Avatar from '@mui/material/Avatar';
import AccountCircleIcon from '@mui/icons-material/AccountCircle';
//api
import { getProfileRequest } from "../../api/auth";
export default function Topbar({first_name,last_name,image}) {
    const [t]=useTranslation();
    const [showprofile, setshowprofile] = useState(false);
    let role ={ 1:"مدير النظام", 2:"مستخدم", 3:"متعهد", 4:"مهندس"}
    //Request
        const[profile,setprofile]=useState({});
        useEffect(()=>{
            async function loadProfile() {
                let response = await getProfileRequest();
                setprofile(response.data.data);
                
            }
            loadProfile();
        },[]);

    return (  
    <div className="top-bar">
        {showprofile && (<Profiledialog
         name={profile?.name}
         first_name={profile?.profile?.first_name}
         last_name={profile?.profile?.last_name}
         image={profile?.profile?.full_image_url ? <Avatar  src={profile?.profile?.full_image_url} alt="img" sx={{ width: 80, height: 80 }} /> :<AccountCircleIcon  sx={{ color: '#f07c1f' ,fontSize:"80px" }} />}
         email={profile?.email}
         phone={profile?.profile?.phone}
         location={profile?.profile?.location}
         role={role[profile?.role_id]}
         onClose={() => setshowprofile(false)}
          />)}
            <div className="title">
                <h1>{t("مرحباً،")} <span>{first_name + " " + last_name}</span></h1>
                <p>{t("نظرة عامة على أداء نظام إعادة الإعمار")}</p>
            </div>
            <div className="user-section">
                <div className="notification">
                    <NotificationsIcon fontSize="medium"/>
                    <div className="notification-badge">3</div>
                </div>
                <div className="user-card" onClick={() => setshowprofile(true)} >
                   {image}
                    <span>{first_name + " " + last_name}</span>
                </div>
            </div>
        </div>
        );
    
}