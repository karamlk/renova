import Snackbar from '@mui/material/Snackbar';
import Alert from "@mui/material/Alert";
import Slide from "@mui/material/Slide";
import { useTranslation } from 'react-i18next';
export default function Snakbar({msg,isopen,setisopen}) {
    const [t] = useTranslation();
    return (
        <Snackbar
        autoHideDuration={3000}
        onClose={()=>{setisopen(false)}}
        anchorOrigin={{vertical: 'top',horizontal: 'center'}}
        open={isopen}
        slots={{transition:Slide}}
        ><Alert
            severity="success"
            variant="filled"
            sx={{
            display: "flex",
            alignItems: "center",
            justifyContent: "center",
            marginRight: "180px",
            width: "220px" ,
            padding: "5px 7px" ,
            fontFamily: "Tajawal",
            fontSize: "16px",
            "& .MuiAlert-icon": {marginLeft: "8px",marginRight: "0px",fontSize: "25px"},
            }}>{t(msg)}</Alert></Snackbar>
    )
}