import "./IconBtn.css";
////MUI Icons
import IconButton from '@mui/material/IconButton';
import Tooltip from '@mui/material/Tooltip';
//Hooks
import { useTranslation } from 'react-i18next';
export default function IconBtn({ name,h=42,w=42,clr="",bgc="",h_clr="",h_bgc="", onClick, icon,className="action-btn"}) {
    const { t } = useTranslation();
  return (
    <Tooltip title={t(name)} arrow>
        <IconButton className={className} 
            sx={{
                color: clr,
                backgroundColor: bgc,
                height: h,
                width: w,
                "&:hover": {backgroundColor: h_bgc,color: h_clr,},}}      
            onClick={() =>{onClick();}}>
            {icon}
        </IconButton>
    </Tooltip>
  );
}