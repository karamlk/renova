import "./Norequest.css";
//MUI
import InboxIcon from '@mui/icons-material/Inbox';
//Hooks
import { useTranslation } from 'react-i18next';

export default function Norequest({text}) {
    const { t } = useTranslation();
    return (
        <div className="no-requests">
            <InboxIcon sx={{fontSize: "90px" , color: "#b8bcbf"}}/>
            <h3>{t(text)}</h3>
        </div>
        
    )
}