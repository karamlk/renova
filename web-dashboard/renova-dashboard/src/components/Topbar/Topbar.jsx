import "./Topbar.css";
//Hooks
import { useState,useContext,useEffect } from "react";
import { useTranslation } from 'react-i18next';
import { useNavigate } from "react-router-dom";
//Commponents
import Profiledialog from "../Profiledialog/Profiledialog";
import Notificationlist from "../Notificationlist/Notificationlist";
//MUI Icons
import NotificationsIcon from '@mui/icons-material/Notifications';
import Avatar from '@mui/material/Avatar';
import AccountCircleIcon from '@mui/icons-material/AccountCircle';
//Context
import {UserContext} from "../../Context/UserContext";
import {NotificationcountContext} from "../../Context/NotificationcountContext";
//api
import { getNotificationListRequest } from "../../api/notification";
import {getNotificationCountRequest} from "../../api/notification";
import {readNotificationRequest} from "../../api/notification";
import {allReadNotificationRequest} from "../../api/notification";
import {deleteNotificationRequest} from "../../api/notification";

export default function Topbar() {
    const [t]=useTranslation();
    const [showprofile, setshowprofile] = useState(false);
    const [shownotification, setshownotification] = useState(false);
    const [notifications, setNotifications] = useState([]);
    const {user}=useContext(UserContext);
    const {N_count,setN_count}=useContext(NotificationcountContext);
    const [page, setPage] = useState(1);
    const [hasMore, setHasMore] = useState(true);
    const [loadingMore, setLoadingMore] = useState(false);
    const navigate = useNavigate();
    let role ={ 1:"مدير النظام", 2:"مستخدم", 3:"متعهد", 4:"مهندس"}
    //Request
    async function getNotificationList(pageNumber = 1) {
    try {
                const response = await getNotificationListRequest(pageNumber);
                const result = response.data;
                if (pageNumber === 1) {
                    setNotifications(result.data);
                } else {
                    setNotifications(prev => [...prev,...result.data]);
                }
                setHasMore(result.next_page_url !== null);
            } catch (error) {
                console.error("فشل جلب الإشعارات:", error);
            }
    }
    async function loadMoreNotifications() {
    if (!hasMore || loadingMore) return;
    setLoadingMore(true);
    try {
        const nextPage = page + 1;
        await getNotificationList(nextPage);
        setPage(nextPage);

    } catch (error) {
        console.error("فشل تحميل المزيد:", error);
    } finally {
        setLoadingMore(false);
    }
    }
    async function getNotificationCount() {
        try {
            const response = await getNotificationCountRequest();
            setN_count(response.data.count);
        } catch (error) {
            console.error("فشل جلب عدد الإشعارات:", error);
        }
    }
    async function readNotification(id) {
        try {
            await readNotificationRequest(id);
            setNotifications(notifications.map(n => n.id === id ? { ...n, is_read: 1 } : n));
            getNotificationCount();
        } catch (error) {
            console.error("فشل قراءة الإشعار:", error);
        }
    }
    async function readAllNotification(){
        try {
            await allReadNotificationRequest();
            setNotifications(notifications.map(n => ({...n,is_read: 1}))
        );
            getNotificationCount();
        } catch (error) {
            console.error("فشل قراءة الإشعارات:", error);
        }
    }
    async function deleteNotification() {
        try {
            await deleteNotificationRequest();
            setNotifications([]);
            getNotificationCount();
        } catch (error) {
            console.error("فشل حذف الإشعارات:", error);
        }
    }
useEffect(() => {
    getNotificationList(1);
    getNotificationCount();
    const interval = setInterval(() => {
        getNotificationList(1);
        getNotificationCount();
    }, 5000);

    return () => {
        clearInterval(interval);
    };
}, []);
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
         onClick={() => {setshowprofile(false);navigate("/dashboard/usersettings")}}
         onClose={() => setshowprofile(false)}
         showEdit={true}
          />)}

            <div className="title">
                <h1>{t("مرحباً،")} <span>{user?.profile?.first_name + " " +user?.profile?.last_name}</span></h1>
                <p>{t("نظرة عامة على أداء نظام إعادة الإعمار")}</p>
            </div>
        <div className="user-section">
            <div className="notification-wrapper">
                <div className="notification" onClick={() =>{shownotification ? setshownotification(false) : setshownotification(true)} }>
                    <NotificationsIcon fontSize="medium"/>
                    <div className="notification-badge">{N_count}</div>
                </div>
                {shownotification && (<Notificationlist 
                            notifications={notifications} 
                            onclick_nav={()=>{getNotificationCount();setshownotification(false);}}
                            onclick_r={readNotification}
                            onclick_ra={()=>{readAllNotification()}}
                            onclick_m={()=>{loadMoreNotifications()}}
                            hasMore={hasMore}
                            loadingMore={loadingMore}
                            delete_all={deleteNotification}
                />)}
            </div>
                <div className="user-card" onClick={() => setshowprofile(true)} >
                   {user?.profile?.full_image_url ? <Avatar  src={user?.profile?.full_image_url} alt="img" sx={{ width: 35, height: 35 }} /> :<AccountCircleIcon  sx={{ color: '#f07c1f' ,fontSize:"80px" }} />}
                    <span>{user?.profile?.first_name + " " + user?.profile?.last_name}</span>
                </div>
            </div>
        </div>
        );
    
}