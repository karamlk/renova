import "./Langswitcher.css";
import LanguageIcon from '@mui/icons-material/Language';
import{useState} from "react";
import i18n from "../../i18n";
export default function Langswitcher() {
    let code=localStorage.getItem("i18nextLng");
    const [codelang,setcodelang]=useState(code);
    function changeLang(){
        if(codelang==="ar"){
            setcodelang("en");
            i18n.changeLanguage("en");
        }else{
            setcodelang("ar");
            i18n.changeLanguage("ar");
        }
    }
    return (      
        <div>
            <button className="lang-btn" onClick={changeLang} >
                <LanguageIcon sx={{color:"#f07c1f"}}/>
                <span className="lang-text">{(codelang==="ar")?"AR":"EN"}</span>
            </button>
        </div>
    )
}