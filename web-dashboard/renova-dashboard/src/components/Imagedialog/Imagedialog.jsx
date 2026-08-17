import "./Imagedialog.css";
import ClearIcon from '@mui/icons-material/Close';
//Components
import IconBtn from "../IconBtn/IconBtn";
export default function Imagedialog({src, onClose}) {
    return (
        <div>
            <div className="image-viewer"  onClick={onClose}>
        <IconBtn h="28px" w="28px" name="" clr="#999" bgc="#f5f5f5" onClick={onClose} icon={<ClearIcon sx={{ color: "#fff" ,fontSize:25 }}/>}/>
        <div className="viewer-content">
            <img id="viewerImage" src={src} alt="الصورة" />
        </div>
    </div>
        </div>
    );
}