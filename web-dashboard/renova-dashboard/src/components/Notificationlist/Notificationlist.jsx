import "./Notificationlist.css";
//MUI
import NotificationsIcon from '@mui/icons-material/Notifications';
import DoneAllIcon from '@mui/icons-material/DoneAll';
import AccessTimeIcon from '@mui/icons-material/AccessTime';
import CheckIcon from '@mui/icons-material/Check';
import AddIcon from '@mui/icons-material/Add';
import HourglassBottomIcon from '@mui/icons-material/HourglassBottom';
import DeleteIcon from '@mui/icons-material/Delete';
//Components
import Button from "../Button/Button";
import Norequest from "../Norequest/Norequest";
//Router
import { NavLink } from "react-router-dom";
//Hooks
import { useContext } from "react";
//Context
import {NotificationcountContext} from "../../Context/NotificationcountContext";
//Labraries
import dayjs from "dayjs";
import relativeTime from "dayjs/plugin/relativeTime";
import "dayjs/locale/ar";
//Hooks
import { useTranslation } from "react-i18next";
export default function Notificationlist({notifications ,onclick_nav , onclick_r , onclick_ra ,onclick_m,hasMore,loadingMore,delete_all}){
    const {N_count}=useContext(NotificationcountContext);
    const { t } = useTranslation();
    dayjs.extend(relativeTime);
    let code=localStorage.getItem("i18nextLng");
    dayjs.locale(code);
    return(
        <div className="notifications-dropdown" >
            <div className="dropdown-header">
                <span className="title">
                    <NotificationsIcon sx={{color : "#f07c1f" , fontSize:"22px"}}/>
                     {t("الإشعارات")}
                    <span className="badge-count" >{N_count}</span>
                </span>
                <div className="noti-btns">
                <Button className="all-read" text="الكل مقروء" icon={<DoneAllIcon sx={{fontSize:"18px"}}/>} onClick={onclick_ra}/>
                <Button className="delete-all" text="حذف الكل" icon={<DeleteIcon sx={{fontSize:"18px"}}/>} onClick={delete_all}/>
                </div>
            </div>
            {notifications.length === 0 ? (<Norequest text="لا يوجد إشعارات"/>):(
                        <div className="dropdown-body">
            {notifications.map((notification) => (
                
                <div className="notification-item">
                    <NavLink to={notification?.target_path} className="notification-info" onClick={() => {
                                if (notification.is_read === 0) {
                                    onclick_r(notification.id);
                                }
                                onclick_nav();
                            }}>
                        <div className="notification-icon"><NotificationsIcon/></div>
                        <div className="content">
                            <div className="title">{t(notification?.title)}</div>
                            <div className="desc">{notification?.message}</div>
                            <div className="time">
                                <AccessTimeIcon sx={{fontSize:"15px"}}/>
                                 <div className="realtime">{dayjs(notification?.created_at.replace("Z", "")).fromNow()}</div>
                                 </div>
                        </div>
                    </NavLink>
                    <div className="actions">
                        {notification.is_read === 0 ?
                        (<Button className="un-read" text="اعتبره مقروء" icon={<CheckIcon sx={{fontSize:"15px"}}/>} onClick={()=>{onclick_r(notification?.id)}}/>):
                        (<Button className="is-read" text="مقروء" />)}
                    </div>
                </div>
            ))}
            {hasMore && (
                <Button className="show-more" text={loadingMore ? t("جاري التحميل...") : t("عرض المزيد")} icon={loadingMore ?<HourglassBottomIcon sx={{fontSize:"16px"}}/>:<AddIcon sx={{fontSize:"16px"}}/>} onClick={onclick_m}/>
                )}
            </div>
            )}

    </div>        
    )
}