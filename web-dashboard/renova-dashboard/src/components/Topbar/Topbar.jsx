import "./Topbar.css";
//// Material UI Icons
import NotificationsIcon from '@mui/icons-material/Notifications';
import AccountCircleIcon from '@mui/icons-material/AccountCircle';
export default function Topbar() {
    return (
    <div className="top-bar">
            <div className="title">
                <h1>مرحباً، <span>أحمد المنصور</span></h1>
                <p>نظرة عامة على أداء نظام إعادة الإعمار</p>
            </div>
            <div className="user-section">
                <div className="notification">
                    <NotificationsIcon />
                    <div className="notification-badge">3</div>
                </div>
                <div className="user-card">
                        <AccountCircleIcon fontSize="large" sx={{ color: '#f07c1f' }} />
                    <span>أحمد المنصور</span>
                </div>
            </div>
        </div>
        );
    
}