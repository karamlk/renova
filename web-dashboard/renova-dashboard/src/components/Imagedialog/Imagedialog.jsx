import "./Imagedialog.css";
import CloseIcon from '@mui/icons-material/Close';

export default function Imagedialog({src, onClose}) {
    return (
        <div>
            <div className="image-viewer"  onClick={onClose}>
        <button className="close-btn" onClick={onClose}>
            <CloseIcon sx={{ color: "#fff" ,fontSize:25 }}/>
        </button>
        <div className="viewer-content">
            <img id="viewerImage" src={src} alt="الصورة" />
        </div>
    </div>
        </div>
    );
}