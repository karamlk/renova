import "./SidebarBtn.css";
//Router
import { NavLink } from "react-router-dom";
//Hooks
import { useTranslation } from 'react-i18next';
export default function SidebarBtn({icon, text, link, className="menu-btn"}) {
    const { t } = useTranslation();
    return (  
    <NavLink  to={link} className={({ isActive }) =>`${className} ${isActive ? "active" : ""}`} >
        {icon}
        <span>{t(text)}</span>
    </NavLink>        
    );
}